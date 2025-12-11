module.exports = async ({ github, context, core }) => {
  const deployOutput = process.env.DEPLOY_OUTPUT;
  let output;

  // Try to extract and parse JSON from the output
  try {
    // First, try to parse as-is
    output = JSON.parse(deployOutput);
  } catch (e) {
    // If that fails, try to extract JSON from the output
    // Find the last occurrence of a complete JSON object (handles nested objects)
    const lines = deployOutput.split('\n');
    let jsonStr = '';
    let braceCount = 0;
    let foundStart = false;

    // Scan from the end to find the last complete JSON object
    for (let i = lines.length - 1; i >= 0; i--) {
      const line = lines[i];
      
      // Count braces in reverse
      for (let j = line.length - 1; j >= 0; j--) {
        const char = line[j];
        if (char === '}') braceCount++;
        if (char === '{') braceCount--;
        
        if (char === '{' && braceCount === 0 && !foundStart) {
          foundStart = true;
          // Found the start of JSON object, extract from here
          jsonStr = lines.slice(i).join('\n').substring(j);
          break;
        }
      }
      
      if (foundStart) break;
    }

    if (jsonStr) {
      try {
        output = JSON.parse(jsonStr);
      } catch (e2) {
        core.error('Failed to parse extracted JSON: ' + e2.message);
        core.info('Raw output: ' + deployOutput);
        return;
      }
    } else {
      core.error('No JSON found in output');
      core.info('Raw output: ' + deployOutput);
      return;
    }
  }

  // Validate output structure
  if (output.status === undefined || output.result === undefined || output.status === "error") {
    core.error('Deploy failed or returned unexpected output');
    core.info(JSON.stringify(output, null, 2));
    return;
  }

  // Extract URLs and expiration time
  const results = Object.values(output.result);
  const expireTime = results[0].expireTime;
  const expireTimeFormatted = new Date(expireTime).toUTCString();
  const urls = results.map((siteResult) => siteResult.url);
  const url = urls.length === 1
    ? `[${urls[0]}](${urls[0]})`
    : urls.map((url) => `- [${url}](${url})`).join("\n");

  const commit = context.sha.substring(0, 7);
  const body = `
🚀 Visit the preview URL for this PR (updated for commit ${commit}):
${url}
<sub>(expires ${expireTimeFormatted})</sub>
  `.trim();

  // Find existing preview comment from this bot
  const { data: comments } = await github.rest.issues.listComments({
    owner: context.repo.owner,
    repo: context.repo.repo,
    issue_number: context.issue.number,
  });

  const botComment = comments.find(comment =>
    comment.user.type === 'Bot' &&
    comment.body.includes('Visit the preview URL for this PR')
  );

  if (botComment) {
    // Update existing comment
    core.info(`Updating existing comment ${botComment.id}`);
    await github.rest.issues.updateComment({
      owner: context.repo.owner,
      repo: context.repo.repo,
      comment_id: botComment.id,
      body: body
    });
  } else {
    // Create new comment
    core.info('Creating new comment');
    await github.rest.issues.createComment({
      owner: context.repo.owner,
      repo: context.repo.repo,
      issue_number: context.issue.number,
      body: body
    });
  }
};
