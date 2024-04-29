<template>
  <RepoList 
    v-for="repo in repos" 
    :key="repo.id" 
    :avatar-url="repo.org_avatar_url || avatarUrl" 
    :avatar-alt="'Organization logo'" 
    :repo-name="repo.full_name" 
    :html-url="repo.html_url" 
    :has-campaign="campaignsByRepoIdentifier[repo.full_name]">
  </RepoList>
</template>

<script>
import RepoList from './components/RepoList.vue';

export default {
  components: {
    RepoList
  },
  mounted() {
    console.log(this.repos);
  },
  data() {
    return {
      avatarUrl: '<%= @avatar.to_json.html_safe %>',
      repos: '<%= @repos.to_json %>',
      campaignsByRepoIdentifier: '<%= @campaigns_by_repo_identifier.to_json.html_safe %>'
    }
  }
}
</script>

<style>
/* Add your styles here */
</style>
