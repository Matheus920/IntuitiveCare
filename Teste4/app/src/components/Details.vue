<template>
  <v-card>
    <v-card-title class="headline grey lighten-2">
      {{company.razao_social}}
      <v-spacer></v-spacer>
      <v-btn icon color="primary" text @click="$emit('closeDetails')">
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </v-card-title>

    <v-card-text class="pt-2">
      <v-text-field v-model="company.registro" label="Registro ANS" disabled></v-text-field>
      <v-text-field v-model="company.nome_fantasia" label="Nome Fantasia" disabled></v-text-field>
      <v-text-field v-model="company.cnpj" label="CNPJ" disabled></v-text-field>
      <v-text-field v-model="company.endereco_eletronico" label="E-mail do Responsável" disabled></v-text-field>
      <v-row>
        <v-col cols="3">
            <v-text-field v-model="company.ddd" label="DDD" disabled></v-text-field>
        </v-col>
        <v-col cols="9">
            <v-text-field v-model="company.telefone" label="Telefone" disabled></v-text-field>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script>
// Componente responsável por exibir os detalhes de uma companhia quando se clica nela.
export default {
  props: {
    company: {
      type: Object
    }
  }
};
</script>