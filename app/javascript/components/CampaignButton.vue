<template>
  <button @click="createCampaign" class="btn btn-primary">
    Create Campaign
  </button>
</template>
  
<script>
export default {
  props: {
    repoName: String
  },
  methods: {
    createCampaign() {
      console.log('Creating campaign for', this.repoName);
      window.location.href = `/users/${this.$props.userId}/campaigns/new?repo_name=${this.repoName}`;
    }
  }
}
</script>
  
<style scoped>
.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-primary:hover {
  background-color: #0056b3;
}
</style>
  