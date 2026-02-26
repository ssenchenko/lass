<script lang="ts">
  import { resolve } from "$app/paths";
  import { m } from "$lib/paraglide/messages.js";
  import { writable } from "svelte/store";

  const isMenuOpen = writable(false);
  function toggleMenu() {
    isMenuOpen.update((value) => !value);
  }
</script>

<header class="bg-gray-800 text-white">
  <nav class="container mx-auto flex items-center justify-between p-4">
    <div class="flex items-center">
      <a href={resolve("/")} class="text-xl font-bold">LASS</a>
      <div class="hidden md:flex items-center space-x-4 ml-8">
        <a href={resolve("/train")} class="hover:text-gray-300">{m.menu_train()}</a>
        <a href={resolve("/vocabulary")} class="hover:text-gray-300">{m.menu_vocabulary()}</a>
      </div>
    </div>
    <div class="hidden md:flex items-center space-x-4">
      <a href={resolve("/login")} class="hover:text-gray-300">{m.menu_login()}</a>
    </div>
    <div class="md:hidden">
      <button on:click={toggleMenu} class="text-white focus:outline-none" aria-label="Menu">
        <svg
          class="w-6 h-6"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M4 6h16M4 12h16m-7 6h7"
          ></path>
        </svg>
      </button>
    </div>
  </nav>
  {#if $isMenuOpen}
    <div class="md:hidden">
      <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
        <a
          href={resolve("/train")}
          class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-gray-700"
          >{m.menu_train()}</a
        >
        <a
          href={resolve("/vocabulary")}
          class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-gray-700"
          >{m.menu_vocabulary()}</a
        >
        <a
          href={resolve("/login")}
          class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-gray-700"
          >{m.menu_login()}</a
        >
      </div>
    </div>
  {/if}
</header>

<div class="container mx-auto p-4 prose">
  <h1>Welcome to SvelteKit</h1>
  <h2>{m.hello_world({ name: "Slava" })}</h2>
  <p>
    Visit <a href="https://svelte.dev/docs/kit">svelte.dev/docs/kit</a> to read the documentation
  </p>
</div>
