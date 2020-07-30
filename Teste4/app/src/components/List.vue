<template>
  <v-container fluid>
    <div v-if="loading" class="text-center">
        <v-progress-circular indeterminate color="primary"></v-progress-circular>
    </div>
    <div v-else-if="items.length > 0">
      <v-list>
        <template v-for="(item, index) in items">
          <v-list-item :key="item.item.registro" @click="handleClick(item.item.registro)">
            <v-list-item-content>
              <v-list-item-title>{{item.item.razao_social}}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>

          <v-divider v-if="index + 1 < items.length" :key="index"></v-divider>
        </template>
      </v-list>
    </div>
    <div v-else>
      <h3 class="text-h5">Nenhum registro encontrado.</h3>
    </div>
    <div>
        <v-dialog v-model="detailsDialog" width="500">
            <Details @closeDetails="detailsDialog = false" :company="selectedCompany"/>
        </v-dialog>
    </div>
  </v-container>
</template>

<script>
// Componente responsável por exibir os resultados na tela.
import Axios from "axios";
import Details from './Details';

export default {
  data: () => ({
    items: [],
    selectedCompany: {},
    index: 0,
    loading: false,
    detailsDialog: false
  }),

  components: {
      Details
  },

  methods: {
    updateItems: function(items) {
      if (!items.message) this.items = items;
    },
    handleClick: function(id) {
      let self = this;
      Axios.get(`http://localhost:3000/details/${id}`)
        .then(response => {
          self.selectedCompany = response.data;
          self.detailsDialog = true;
        })
        .catch(error => {
          console.error(error);
        });
    },
    updateLoading: function(state){
        this.loading = state;
    }
  }
};
</script>