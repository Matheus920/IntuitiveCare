<template>
  <v-app>
    <v-app-bar
      app
      color="primary"
      dark
    >
      <div class="d-flex align-center">
        <v-img
          alt="IntuitiveCare Logo"
          class="shrink mr-2"
          contain
          :src="require('./assets/intuitivecare.png')"
          transition="scale-transition"
          width="40"
        />

        <v-toolbar-title>IntuitiveCare</v-toolbar-title>
      </div>

      <v-spacer></v-spacer>

      <v-btn
        href="https://github.com/Matheus920/IntuitiveCare"
        target="_blank"
        text
      >
        <span class="mr-2">Outros Testes</span>
        <v-icon>mdi-open-in-new</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <Banner @searched="updateResults" @loading="updateLoading"/>
      <List ref="listChildren"/>
    </v-main>
  </v-app>
</template>

<script>
import Banner from './components/Banner';
import List from './components/List';

export default {
  name: 'App',

  components: {
    Banner,
    List
  },

  data: () => ({
    //
  }),

  methods: {
    updateResults($event) {
      this.$refs.listChildren.updateItems($event);
    },
    updateLoading($event){
      this.$refs.listChildren.updateLoading($event);
    }
  }
};
</script>
