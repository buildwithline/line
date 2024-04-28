<template>
  <div id="vue-app">
    <CampaignButton :items="items" />
  </div>
</template>

<script>
import CampaignButton from './components/CampaignButton.vue'

export default {
  components: {
    CampaignButton
  },
  data() {
    return {
      items: [
        { name: 'Bamboo Thermal Ski Coat', price: '$75' },
        { name: 'Bamboo Thermal Ski gloves', price: '$12' },
        { name: 'Bamboo Thermal Ski HAT', price: '$15' },
        { name: 'Bamboo Thermal Ski glasses', price: '$45' },
        { name: 'Bamboo Thermal Ski scarf', price: '$35' }
      ]
    }
  }
}
</script>

