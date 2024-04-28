<!-- <script>
document.addEventListener('DOMContentLoaded', () => {
  const { createApp } = Vue;

  const CampaignButton = {
    props: ['repoName'],
    template: `<button @click="createCampaign">Create Campaign for {{ repoName }}</button>`,
    methods: {
      createCampaign() {
        console.log('Creating campaign for', this.repoName);
      }
    }
  };
});
</script> -->

<template>
  <div>
    <ul>
      <li v-for="item in items" :key="item.name">
        <span>{{ item.name }}</span> - <span>{{ item.price }}</span>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    props: {
      items: Array
    }
  }
</script>