<script lang="ts">
	let fieldA: string = '';
	let fieldBs: string[] = [''];
  
	// Add more Field B
	function addFieldB() {
	  fieldBs = [...fieldBs, ''];
	}
  
	// Update Field B values dynamically
	function updateFieldB(index: number, event: Event) {
	  const target = event.target as HTMLInputElement;
	  fieldBs[index] = target.value;
	}
  
	// Data to be displayed in the table
	interface TableData {
	  fieldA: string;
	  fieldBs: string[];
	}
	
	let tableData: TableData[] = [];
  
	// Submit form and add data to table
	function submitForm() {
	  tableData = [...tableData, { fieldA, fieldBs }];
  
	  // Reset the form
	  fieldA = '';
	  fieldBs = [''];
	}
  </script>
  
  <style>
	.container {
	  width: 80%;
	  margin: 20px auto;
	  padding: 20px;
	  background-color: #fff;
	  border-radius: 8px;
	  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	}
  
	form {
	  display: flex;
	  flex-direction: column;
	  margin-bottom: 20px;
	}
  
	label {
	  margin-top: 10px;
	  font-weight: bold;
	}
  
	input[type="text"] {
	  padding: 8px;
	  margin-top: 5px;
	  border: 1px solid #ccc;
	  border-radius: 4px;
	}
  
	button {
	  margin-top: 10px;
	  padding: 10px;
	  background-color: #4CAF50;
	  color: white;
	  border: none;
	  border-radius: 4px;
	  cursor: pointer;
	}
  
	button:hover {
	  background-color: #45a049;
	}
  
	table {
	  width: 100%;
	  border-collapse: collapse;
	}
  
	table, th, td {
	  border: 1px solid black;
	}
  
	th, td {
	  padding: 10px;
	  text-align: left;
	}
  </style>
  
  <div class="container">
	<h1>Form with Multiple B Fields</h1>
  
	<!-- Form Section -->
	<form on:submit|preventDefault={submitForm}>
	  <label for="fieldA">Field A:</label>
	  <input type="text" id="fieldA" bind:value={fieldA} required />
  
	  <div id="fieldBContainer">
		{#each fieldBs as fieldB, index}
		  <label for="fieldB{index}">Field B {index + 1}:</label>
		  <input
			type="text"
			id="fieldB{index}"
			value={fieldB}
			on:input={event => updateFieldB(index, event)}
			required
		  />
		{/each}
	  </div>
  
	  <button type="button" on:click={addFieldB}>Add More B</button>
	  <button type="submit">Submit</button>
	</form>
  
	<!-- Table Section -->
	<h2>Submitted Data</h2>
	<table>
	  <thead>
		<tr>
		  <th>Field A</th>
		  <th>Field B</th>
		</tr>
	  </thead>
	  <tbody>
		{#each tableData as row}
		  <tr>
			<td>{row.fieldA}</td>
			<td>{row.fieldBs.join(', ')}</td>
		  </tr>
		{/each}
	  </tbody>
	</table>
  </div>
  