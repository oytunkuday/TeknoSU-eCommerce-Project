window.config = {
  transpiler: "plugin-babel",
  meta: {
    "*.vue": {
      loader: "vue-loader",
    },
    "devextreme/localization.js": {
      esModule: true,
    },
  },
  paths: {
    "npm:": "https://unpkg.com/",
  },
  map: {
    vue: "npm:vue@3.0.0/dist/vue.esm-browser.js",
    "vue-loader": "npm:dx-systemjs-vue-browser@1.0.15/index.js",
    mitt: "npm:mitt/dist/mitt.umd.js",
    rrule: "npm:rrule@2.6.4/dist/es5/rrule.js",
    luxon: "npm:luxon@1.28.0/build/global/luxon.min.js",
    "es6-object-assign": "npm:es6-object-assign@1.1.0",
    devextreme: "npm:devextreme@22.1.3/cjs",
    "devextreme-vue": "npm:devextreme-vue@22.1.3",
    jszip: "npm:jszip@3.7.1/dist/jszip.min.js",
    "devextreme-quill": "npm:devextreme-quill@1.5.16/dist/dx-quill.min.js",
    "devexpress-diagram": "npm:devexpress-diagram@2.1.57/dist/dx-diagram.js",
    "devexpress-gantt": "npm:devexpress-gantt@4.1.30/dist/dx-gantt.js",
    "@devextreme/runtime": "npm:@devextreme/runtime@3.0.7",
    inferno: "npm:inferno@7.4.4/dist/inferno.min.js",
    "inferno-compat": "npm:inferno-compat@7.4.11/dist/inferno-compat.min.js",
    "inferno-create-element":
      "npm:inferno-create-element@7.4.11/dist/inferno-create-element.min.js",
    "inferno-dom": "npm:inferno-dom/dist/inferno-dom.min.js",
    "inferno-hydrate": "npm:inferno-hydrate@7.4.11/dist/inferno-hydrate.min.js",
    "inferno-clone-vnode":
      "npm:inferno-clone-vnode@7.4.11/dist/inferno-clone-vnode.min.js",
    "inferno-create-class":
      "npm:inferno-create-class@7.4.11/dist/inferno-create-class.min.js",
    "inferno-extras": "npm:inferno-extras@7.4.11/dist/inferno-extras.min.js",
    "plugin-babel": "npm:systemjs-plugin-babel@0.0.25/plugin-babel.js",
    "systemjs-babel-build":
      "npm:systemjs-plugin-babel@0.0.25/systemjs-babel-browser.js",
  },
  packages: {
    "devextreme-vue": {
      main: "index.js",
    },
    devextreme: {
      defaultExtension: "js",
    },
    "devextreme/events/utils": {
      main: "index",
    },
    "devextreme/events": {
      main: "index",
    },
    "es6-object-assign": {
      main: "./index.js",
      defaultExtension: "js",
    },
  },
  packageConfigPaths: [
    "npm:@devextreme/*/package.json",
    "npm:@devextreme/runtime@3.0.7/inferno/package.json",
  ],
  babelOptions: {
    sourceMaps: false,
    stage0: true,
  },
};
System.config(window.config);
