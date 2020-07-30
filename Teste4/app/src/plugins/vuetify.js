import Vue from 'vue';
import Vuetify from 'vuetify/lib';
import colors from 'vuetify/lib/util/colors';

Vue.use(Vuetify);

export default new Vuetify({
    theme: {
        themes: {
            dark: {
                primary: colors.shades.black
            },
            light: {
                primary: colors.shades.black,
                secondary: colors.grey.lighten2
            }
        }
    }
});
