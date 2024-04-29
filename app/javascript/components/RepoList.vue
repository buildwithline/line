<template>
  <div>
    <table v-if="repos && repos.length > 0" class="min-w-full divide-y divide-gray-200">
      <tbody class="bg-white divide-y divide-gray-200">
        <tr v-for="repo in repos" :key="repo.id">
          <td class="px-6 py-4 whitespace-nowrap">
            <div class="flex justify-between items-center w-full">
              <div class="flex items-center">
                <img :src="repo.org_avatar_url || avatarUrl" :alt="repo.org_avatar_url ? 'Organization logo' : avatarAlt" class="w-8 h-8 mr-4 rounded-full">
                <span class="font-medium text-gray-900">
                  {{ repo.full_name }}
                </span>
              </div>
              <div>
                <button v-if="campaignsByRepoIdentifier[repo.full_name]" @click="showCampaign(repo)" class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
                  Show Campaign
                </button>
                <button v-else @click="createCampaign(repo)" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                  Create Campaign
                </button>
              </div>
              <div>
                <a :href="repo.html_url" class="text-blue-600 hover:text-blue-800">
                  {{ repo.html_url }}
                </a>
                <button @click="copyToClipboard(repo.html_url)" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 ml-2 rounded">
                  Copy URL
                </button>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else class="text-gray-600">No repos found.</p>
  </div>
</template>
  
<script>
export default {
  props: {
    repos: {
      type: Array,
      required: true
    },
    avatarUrl: {
      type: String,
      required: true
    },
    avatarAlt: {
      type: String,
      default: "User logo"
    },
    campaignsByRepoIdentifier: {
      type: Object,
      default: () => ({})
    }
  },
  mounted() {
    console.log('repos:', this.repos);
  },
  methods: {
    showCampaign(repo) {
      // Implement the logic to show details of the campaign
      console.log('Showing campaign for:', repo.full_name);
    },
    createCampaign(repo) {
      // Implement the logic to create a campaign
      console.log('Creating campaign for:', repo.full_name);
    },
    copyToClipboard(url) {
      navigator.clipboard.writeText(url).then(() => {
        alert('URL copied to clipboard!');
      }).catch(err => {
        console.error('Failed to copy URL: ', err);
      });
    }
  }
}
  </script>
  