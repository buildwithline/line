<template>
  <campaign-button v-for="(repo, index) in repoNames" :key="index" :repo-name="repo"></campaign-button>
</template>

<script>
  export default {
    props: {
      repoNames: Array
    },
    methods: {
      createCampaign() {
        console.log('Creating campaign for', this.repoName);
      }
    }
  }
</script>