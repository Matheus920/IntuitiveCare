<template>
  <v-container class="secondary mx-0" fluid>
    <v-row class="text-center">
      <v-col cols="12">
        <h1 class="display-2 font-weight-bold">Teste 4: FrontEnd</h1>
      </v-col>
      <v-col cols="12">
        <h3
          class="text-h5"
        >Para realizar a sua busca basta entrar com o texto desejado no campo abaixo.</h3>
      </v-col>
    </v-row>
    <v-row class="justify-center">
      <v-col cols="6">
        <v-text-field
          v-model="searchText"
          label="Entre com o termo da pesquisa"
          append-outer-icon="mdi-information-outline"
          append-icon="mdi-delete"
          :rules="[rules.required, rules.counter]"
          @click:append="clearMessage"
          @click:append-outer="infoDialog = true"
          @input="performSearch"
        ></v-text-field>
      </v-col>
    </v-row>
    <div class="text-center">
      <v-dialog v-model="infoDialog" width="500">
        <v-card>
          <v-card-title class="headline grey lighten-2">
            Informações
            <v-spacer></v-spacer>
            <v-btn icon color="primary" text @click="infoDialog = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </v-card-title>

          <v-card-text class="pt-2">
            Para a realização desse teste é possível pesquisar sobre os campos de CNPJ, Registro ANS, Nome Fantasia e Razão Social.
            Não é possível utilizar campos concatenados.
          </v-card-text>
        </v-card>
      </v-dialog>
    </div>
  </v-container>
</template>

<script>
import Axios from "axios";
import _ from "lodash";

export default {
  data: () => ({
    searchText: "",
    rules: {
      required: value => !!value || "Campo não pode ser vazio.",
      counter: value =>
        (value.length <= 255 && value.length >= 3) ||
        "Campo deve ter entre 3 e 255 caracteres."
    },
    infoDialog: false,
    occurrences: []
  }),

  methods: {
    clearMessage() {
      this.searchText = "";
      this.$emit('searched', []);
    },

    performSearch: _.debounce(function () {
      this.$emit('loading', true);

      if(!this.searchText){
          this.$emit('searched', []);
          this.$emit('loading', false);
          return;
      }

      if (
        this.searchText.length >= 3 &&
        this.searchText.length <= 255
      ) {
        let self = this
        Axios.get(`http://localhost:3000/${self.searchText}`)
          .then(function(response) {
            self.$emit('searched', response.data);
          })
          .catch(function(error) {
            console.error(error);
            self.$emit('searched', {message: 'Algo deu errado!'});
          })
          .finally(() => {
              self.$emit('loading', false);
          })
      } else {
          this.$emit('loading', false);
      }
    }, 500)
  }
};
</script>