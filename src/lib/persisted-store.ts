/**
 * A tiny external store backed by localStorage, shaped for useSyncExternalStore.
 *
 * Reading persisted state with `useState` + `useEffect` is the obvious approach
 * and the wrong one: it sets state during an effect, which cascades renders and
 * flashes the empty value on every page load. localStorage is an external
 * system, so React has a purpose-built hook for it — this adapts one key to it.
 *
 * `getServerSnapshot` returns the same frozen fallback every time. Returning a
 * fresh object would loop forever, since React compares snapshots by identity.
 *
 * Subscribing to `storage` events comes free with this design and is worth
 * having: a cart edited in one tab now updates in the others.
 */
export interface PersistedStore<T> {
  subscribe: (onChange: () => void) => () => void;
  getSnapshot: () => T;
  getServerSnapshot: () => T;
  set: (next: T) => void;
  update: (fn: (current: T) => T) => void;
}

export function createPersistedStore<T>(
  key: string,
  fallback: T,
  /** Guards against corrupt or outdated stored values. */
  validate: (value: unknown) => value is T,
): PersistedStore<T> {
  // `undefined` means "not read yet"; the first getSnapshot resolves it.
  let cache: T | undefined;
  const listeners = new Set<() => void>();

  function read(): T {
    try {
      const raw = localStorage.getItem(key);
      if (raw === null) return fallback;
      const parsed: unknown = JSON.parse(raw);
      return validate(parsed) ? parsed : fallback;
    } catch {
      // Private browsing, blocked site data, corrupt JSON.
      return fallback;
    }
  }

  function emit() {
    for (const listener of listeners) listener();
  }

  return {
    subscribe(onChange) {
      listeners.add(onChange);

      // Another tab wrote this key. Drop the cache so the next snapshot re-reads.
      const onStorage = (event: StorageEvent) => {
        if (event.key === key || event.key === null) {
          cache = undefined;
          emit();
        }
      };
      window.addEventListener("storage", onStorage);

      return () => {
        listeners.delete(onChange);
        window.removeEventListener("storage", onStorage);
      };
    },

    getSnapshot() {
      if (cache === undefined) cache = read();
      return cache;
    },

    getServerSnapshot() {
      return fallback;
    },

    set(next) {
      cache = next;
      try {
        localStorage.setItem(key, JSON.stringify(next));
      } catch {
        // Still works for this page view; it just will not survive a reload.
      }
      emit();
    },

    update(fn) {
      this.set(fn(this.getSnapshot()));
    },
  };
}

/**
 * True only after hydration. Lets a component render the server markup first
 * and then switch to client-only state without setting state in an effect.
 */
export const hydrationStore = {
  subscribe: () => () => {},
  getSnapshot: () => true,
  getServerSnapshot: () => false,
};
