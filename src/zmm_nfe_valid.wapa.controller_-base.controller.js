sap.ui.define(["sap/ui/core/mvc/Controller","sap/ui/core/UIComponent","sap/ui/core/routing/History"],function(e,t,n){"use strict";return e.extend("umicore.mm.nfevalid.zmmnfevalid.controller.Base",{onInit:function(){},getRouter:function(){return t.getRout+
erFor(this)},onNavBack:function(){var e,t;e=n.getInstance();t=e.getPreviousHash();if(t!==undefined){window.history.go(-1)}else{this.getRouter().navTo("TargetList",{},true)}},sayHello:function(e){},hide:function(e,t){t.setVisible(false);var n=t.getLabels(+
);n.forEach(t=>{var n=e.byId(t.sId);n.setVisible(false)})},disable:function(e,t){t.setEditable(false);var n=t.getLabels();n.forEach(t=>{var n=e.byId(t.sId);if(n.setEditable){n.setEditable(false)}})},getGlobalModel:function(){var e=this.getOwnerComponent(+
).getModel("global");return e},cnpjUnmask:function(e){var t=e;t=t.replace(".","");t=t.replace(".","");t=t.replace("/","");t=t.replace("-","");return t},getI18nText:function(e){return this.getView().getModel("i18n").getResourceBundle().getText(e)}})});    