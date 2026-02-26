<script lang="ts">
  import "../app.css";
  import { resolve } from "$app/paths";
  import favicon from "$lib/assets/favicon.svg";
  import { locales, localizeHref } from "$lib/paraglide/runtime";
  import { page } from "$app/state";

  let { children } = $props();
</script>

<svelte:head>
  <link rel="icon" href={favicon} />
</svelte:head>

<div style="display:none">
  {#each locales as locale (locale)}
    <!-- eslint-disable-next-line svelte/no-navigation-without-resolve -->
    <a href={localizeHref(resolve(page.url.pathname), { locale })}>{locale}</a>
  {/each}
</div>

{@render children?.()}
