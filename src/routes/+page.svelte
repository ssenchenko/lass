<script lang="ts">
	let original: string = '';
	let translations: string[] = [''];
    let imageUrl: string = '';
    let showPopup: boolean = false;
    let imageResults: any[] = [];

    async function findImage() {
        if (!original) return;
        try {
            const response = await fetch(`/api/imagesearch?query=${original}`);
            if (!response.ok) {
                const errorData = await response.json();
                console.error('API error:', errorData);
                // Handle error, e.g., show a message to the user
                return;
            }
            const data = await response.json();
            imageResults = data.results;
            showPopup = true;
        } catch (error) {
            console.error('Fetch error:', error);
            // Handle network error
        }
    }

    function selectImage(url: string) {
        imageUrl = url;
        showPopup = false;
    }

	// Add more Field B
	function addTranslation() {
	  translations = [...translations, ''];
	}

	// Update Field B values dynamically
	function updateTranslations(index: number, event: Event) {
	  const target = event.target as HTMLInputElement;
	  translations[index] = target.value;
	}

	// Data to be displayed in the table
	interface TableData {
	  original: string;
	  translations: string[];
	}

	let tableData: TableData[] = [];

	// Submit form and add data to table
	function submitForm() {
	  tableData = [...tableData, { original, translations }];

	  // Reset the form
	  original = '';
	  translations = [''];
	}
</script>

<style>
	.container {
	  max-width: 960px;
	  margin: 5rem auto;
	  padding: 4rem;
	  background-color: var(--color-surface);
	  border-radius: 8px;
	  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
	}

	form {
	  display: grid;
      gap: 2rem;
	  margin-bottom: 2rem;
	}

    #translationContainer {
        display: grid;
        gap: 1.5rem;
    }

	label {
	  font-weight: 500;
      font-size: 1.1rem;
	}

	input[type="text"] {
	  width: 100%;
      box-sizing: border-box;
	  font-size: 1.1rem;
	  font-weight: 400;
	}

    .image-search {
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .image-url {
        font-size: 0.9rem;
        color: var(--color-muted);
    }

    .form-actions {
        display: flex;
        gap: 1rem;
        margin-top: 1rem;
    }

	h1 {
	  color: var(--color-primary);
	  font-weight: 700;
	  text-align: center;
	  margin-bottom: 2rem;
	}

	button {
      font-weight: 500;
	  border: 1px solid var(--color-primary);
	  background-color: transparent;
	  color: var(--color-primary);
      transition: all 0.2s ease;
	}

	button:hover {
	  background-color: #FFF2F2;
      border-color: var(--color-primary-hover);
	}

    button[type="submit"] {
        background-color: var(--color-primary);
        color: white;
        border-color: var(--color-primary);
    }

    button[type="submit"]:hover {
        background-color: var(--color-primary-hover);
        border-color: var(--color-primary-hover);
    }


	table {
	  width: 100%;
	  border-collapse: collapse;
      margin-top: 1rem;
	}

	th, td {
	  padding: 1rem;
	  text-align: left;
	  border-bottom: 1px solid var(--color-border);
	}

    th {
        font-weight: 600;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    tbody tr:nth-child(even) {
        background-color: var(--color-bg);
    }

    .popup-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .popup {
        background-color: white;
        padding: 2rem;
        border-radius: 8px;
        max-width: 80%;
        max-height: 80%;
        overflow-y: auto;
    }

    .image-results {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 1rem;
        margin-top: 1rem;
    }

    .image-results img {
        width: 100%;
        height: 100px;
        object-fit: cover;
        cursor: pointer;
        border-radius: 4px;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .container {
            margin: 2rem auto;
            padding: 2rem;
        }

        table, thead, tbody, th, td, tr {
            display: block;
        }

        thead tr {
            position: absolute;
            top: -9999px;
            left: -9999px;
        }

        tr {
            border: 1px solid var(--color-border);
            margin-bottom: 1rem;
        }

        td {
            border: none;
            border-bottom: 1px solid #eee;
            position: relative;
            padding-left: 50%;
        }

        td:before {
            position: absolute;
            top: 0;
            left: 6px;
            width: 45%;
            padding-right: 10px;
            white-space: nowrap;
            font-weight: 600;
        }

        td:nth-of-type(1):before { content: "Field A"; }
        td:nth-of-type(2):before { content: "Field B"; }
    }
</style>

<div class="container">
	<h1>Add new word or phrase</h1>

	<!-- Form Section -->
	<form on:submit|preventDefault={submitForm}>
	  <label for="original">Word/phrase:</label>
	  <input type="text" id="original" bind:value={original} required />
      <div class="image-search">
        <button type="button" on:click={findImage}>Find Image</button>
        <span class="image-url">{imageUrl}</span>
      </div>

	  <div id="translationContainer">
		{#each translations as translation, index}
		  <label for="translation{index}">Translation {index + 1}:</label>
		  <input
			type="text"
			id="translation{index}"
			value={translation}
			on:input={event => updateTranslations(index, event)}
			required
		  />
		{/each}
	  </div>

      <div class="form-actions">
	    <button type="button" on:click={addTranslation}>Add Translation</button>
	    <button type="submit">Save</button>
      </div>
	</form>

	<!-- Table Section -->
	<h2>Submitted Data</h2>
	<table>
	  <thead>
		<tr>
		  <th>Word/Phrase</th>
		  <th>Translations</th>
		</tr>
	  </thead>
	  <tbody>
		{#each tableData as row}
		  <tr>
			<td>{row.original}</td>
			<td>{row.translations.join(', ')}</td>
		  </tr>
		{/each}
	  </tbody>
	</table>
</div>

{#if showPopup}
  <div class="popup-overlay">
    <div class="popup">
      <h2>Select an Image</h2>
      <div class="image-results">
        {#each imageResults as image}
          <img src={image.url} alt={image.title} on:click={() => selectImage(image.url)} />
        {/each}
      </div>
      <button on:click={() => showPopup = false}>Close</button>
    </div>
  </div>
{/if}