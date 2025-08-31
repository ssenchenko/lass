import { json } from '@sveltejs/kit';
import { SecretManagerServiceClient } from '@google-cloud/secret-manager';

const client = new SecretManagerServiceClient();

async function getSecret(secretName: string): Promise<string | undefined> {
    const projectId = process.env.GCP_PROJECT; // Assumes GCP_PROJECT is set as an env var
    if (!projectId) {
        console.error('GCP_PROJECT environment variable is not set.');
        return undefined;
    }
    const name = `projects/${projectId}/secrets/${secretName}/versions/latest`;
    try {
        const [version] = await client.accessSecretVersion({ name });
        return version.payload?.data?.toString();
    } catch (error) {
        console.error(`Failed to access secret ${secretName}:`, error);
        return undefined;
    }
}

export async function GET({ url }) {
    const query = url.searchParams.get('query');

    if (!query) {
        return json({ error: 'Query parameter is missing' }, { status: 400 });
    }

    // Retrieve secrets from Secret Manager at runtime
    const GOOGLE_API_KEY = await getSecret('GOOGLE_API_KEY'); // Use the secret name you set
    const GOOGLE_CSE_ID = await getSecret('GOOGLE_CSE_ID');   // Use the secret name you set

    if (!GOOGLE_API_KEY || !GOOGLE_CSE_ID) {
        console.error('Google API Key or CSE ID could not be retrieved from Secret Manager.');
        return json({ error: 'Server configuration error: API keys missing.' }, { status: 500 });
    }

    try {
        const response = await fetch(
            `https://www.googleapis.com/customsearch/v1?key=${GOOGLE_API_KEY}&cx=${GOOGLE_CSE_ID}&q=${query}&searchType=image`
        );

        if (!response.ok) {
            const errorData = await response.json();
            console.error('Google Custom Search API error:', errorData);
            return json({ error: 'Failed to fetch images from Google API', details: errorData }, { status: response.status });
        }

        const data = await response.json();
        const images = data.items?.map((item: any) => ({
            url: item.link,
            title: item.title
        })) || [];

        return json({ results: images });

    } catch (error) {
        console.error('Error in image search API route:', error);
        return json({ error: 'Internal server error during image search' }, { status: 500 });
    }
}
