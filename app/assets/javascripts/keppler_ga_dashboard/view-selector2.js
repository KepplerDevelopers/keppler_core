! function(t) {
  function e(r) {
    if (i[r]) return i[r].exports;
    var s = i[r] = {
      exports: {},
      id: r,
      loaded: !1
    };
    return t[r].call(s.exports, s, s.exports, e), s.loaded = !0, s.exports
  }
  var i = {};
  return e.m = t, e.c = i, e.p = "", e(0)
}([function(t, e, i) {
  "use strict";

  function r(t) {
    return t && t.__esModule ? t : {
      "default": t
    }
  }
  var s = i(1),
    n = r(s);
  gapi.analytics.ready(function() {
    function t(t, e, i) {
      t.innerHTML = e.map(function(t) {
        var e = t.id == i ? "selected " : " ";
        return "<option " + e + 'value="' + t.id + '">' + t.name + "</option>"
      }).join("")
    }

    function e(t) {
      return t.ids || t.viewId ? {
        prop: "viewId",
        value: t.viewId || t.ids && t.ids.replace(/^ga:/, "")
      } : t.propertyId ? {
        prop: "propertyId",
        value: t.propertyId
      } : t.accountId ? {
        prop: "accountId",
        value: t.accountId
      } : void 0
    }
    gapi.analytics.createComponent("ViewSelector2", {
      execute: function() {
        return this.setup_(function() {
          this.updateAccounts_(), this.changed_ && (this.render_(), this.onChange_())
        }.bind(this)), this
      },
      set: function(t) {
        if (!!t.ids + !!t.viewId + !!t.propertyId + !!t.accountId > 1) throw new Error('You cannot specify more than one of the following options: "ids", "viewId", "accountId", "propertyId"');
        if (t.container && this.container) throw new Error("You cannot change containers once a view selector has been rendered on the page.");
        var e = this.get();
        return (e.ids != t.ids || e.viewId != t.viewId || e.propertyId != t.propertyId || e.accountId != t.accountId) && (e.ids = null, e.viewId = null, e.propertyId = null, e.accountId = null), gapi.analytics.Component.prototype.set.call(this, t)
      },
      setup_: function(t) {
        function e() {
          n["default"].get().then(function(e) {
            i.summaries = e, i.accounts = i.summaries.all(), t()
          }, function(t) {
            i.emit("error", t)
          })
        }
        var i = this;
        gapi.analytics.auth.isAuthorized() ? e() : gapi.analytics.auth.on("success", e)
      },
      updateAccounts_: function() {
        var t, i, r, s = this.get(),
          n = e(s);
        if (n) switch (n.prop) {
          case "viewId":
            t = this.summaries.getProfile(n.value), i = this.summaries.getAccountByProfileId(n.value), r = this.summaries.getWebPropertyByProfileId(n.value);
            break;
          case "propertyId":
            r = this.summaries.getWebProperty(n.value), i = this.summaries.getAccountByWebPropertyId(n.value), t = r && r.views && r.views[0];
            break;
          case "accountId":
            i = this.summaries.getAccount(n.value), r = i && i.properties && i.properties[0], t = r && r.views && r.views[0]
        } else i = this.accounts[0], r = i && i.properties && i.properties[0], t = r && r.views && r.views[0];
        i || r || t ? (i != this.account || r != this.property || t != this.view) && (this.changed_ = {
          account: i && i != this.account,
          property: r && r != this.property,
          view: t && t != this.view
        }, this.account = i, this.properties = i.properties, this.property = r, this.views = r && r.views, this.view = t, this.ids = t && "ga:" + t.id) : this.emit("error", new Error("You do not have access to " + n.prop.slice(0, -2) + " : " + n.value))
      },
      render_: function() {
        var e = this.get();
        this.container = "string" == typeof e.container ? document.getElementById(e.container) : e.container, this.container.innerHTML = e.template || this.template;
        var i = this.container.querySelectorAll("select"),
          r = this.accounts,
          s = this.properties || [{
            name: "(Empty)",
            id: ""
          }],
          n = this.views || [{
            name: "(Empty)",
            id: ""
          }];
        t(i[0], r, this.account.id), t(i[1], s, this.property && this.property.id), t(i[2], n, this.view && this.view.id), i[0].onchange = this.onUserSelect_.bind(this, i[0], "accountId"), i[1].onchange = this.onUserSelect_.bind(this, i[1], "propertyId"), i[2].onchange = this.onUserSelect_.bind(this, i[2], "viewId")
      },
      onChange_: function() {
        var t = {
          account: this.account,
          property: this.property,
          view: this.view,
          ids: this.view && "ga:" + this.view.id
        };
        this.changed_ && (this.changed_.account && this.emit("accountChange", t), this.changed_.property && this.emit("propertyChange", t), this.changed_.view && (this.emit("viewChange", t), this.emit("idsChange", t), this.emit("change", t.ids))), this.changed_ = null
      },
      onUserSelect_: function(t, e) {
        var i = {};
        i[e] = t.value, this.set(i), this.execute()
      },
      template: '<div class="ViewSelector2 row">  <div class="ViewSelector2-item col s4" style="display:none;">    <label>Cuenta</label>    <select class="form-control"></select>  </div>  <div class="ViewSelector2-item col-md-6">    <label>Propiedad</label>    <select class="form-control"></select>  </div>  <div class="ViewSelector2-item col-md-6">    <label>Vista</label>    <select class="form-control"></select>  </div></div>'
    })
  })
}, function(t, e, i) {
  function r() {
    var t = gapi.client.request({
      path: o
    }).then(function(t) {
      return t
    });
    return new t.constructor(function(e, i) {
      var r = [];
      t.then(function s(t) {
        var a = t.result;
        a.items ? r = r.concat(a.items) : i(new Error("You do not have any Google Analytics accounts. Go to http://google.com/analytics to sign up.")), a.startIndex + a.itemsPerPage <= a.totalResults ? gapi.client.request({
          path: o,
          params: {
            "start-index": a.startIndex + a.itemsPerPage
          }
        }).then(s) : e(new n(r))
      }).then(null, i)
    })
  }
  var s, n = i(2),
    o = "/analytics/v3/management/accountSummaries";
  t.exports = {
    get: function(t) {
      return t && (s = null), s || (s = r())
    }
  }
}, function(t, e, i) {
  function r(t) {
    this.accounts_ = t, this.webProperties_ = [], this.profiles_ = [], this.accountsById_ = {}, this.webPropertiesById_ = this.propertiesById_ = {}, this.profilesById_ = this.viewsById_ = {};
    for (var e, i = 0; e = this.accounts_[i]; i++)
      if (this.accountsById_[e.id] = {
          self: e
        }, e.webProperties) {
        s(e, "webProperties", "properties");
        for (var r, n = 0; r = e.webProperties[n]; n++)
          if (this.webProperties_.push(r), this.webPropertiesById_[r.id] = {
              self: r,
              parent: e
            }, r.profiles) {
            s(r, "profiles", "views");
            for (var o, a = 0; o = r.profiles[a]; a++) this.profiles_.push(o), this.profilesById_[o.id] = {
              self: o,
              parent: r,
              grandParent: e
            }
          }
      }
  }

  function s(t, e, i) {
    Object.defineProperty ? Object.defineProperty(t, i, {
      get: function() {
        return t[e]
      }
    }) : t[i] = t[e]
  }
  r.prototype.all = function() {
    return this.accounts_
  }, s(r.prototype, "all", "allAccounts"), r.prototype.allWebProperties = function() {
    return this.webProperties_
  }, s(r.prototype, "allWebProperties", "allProperties"), r.prototype.allProfiles = function() {
    return this.profiles_
  }, s(r.prototype, "allProfiles", "allViews"), r.prototype.get = function(t) {
    if (!!t.accountId + !!t.webPropertyId + !!t.propertyId + !!t.profileId + !!t.viewId > 1) throw new Error('get() only accepts an object with a single property: either "accountId", "webPropertyId", "propertyId", "profileId" or "viewId"');
    return this.getProfile(t.profileId || t.viewId) || this.getWebProperty(t.webPropertyId || t.propertyId) || this.getAccount(t.accountId)
  }, r.prototype.getAccount = function(t) {
    return this.accountsById_[t] && this.accountsById_[t].self
  }, r.prototype.getWebProperty = function(t) {
    return this.webPropertiesById_[t] && this.webPropertiesById_[t].self
  }, s(r.prototype, "getWebProperty", "getProperty"), r.prototype.getProfile = function(t) {
    return this.profilesById_[t] && this.profilesById_[t].self
  }, s(r.prototype, "getProfile", "getView"), r.prototype.getAccountByProfileId = function(t) {
    return this.profilesById_[t] && this.profilesById_[t].grandParent
  }, s(r.prototype, "getAccountByProfileId", "getAccountByViewId"), r.prototype.getWebPropertyByProfileId = function(t) {
    return this.profilesById_[t] && this.profilesById_[t].parent
  }, s(r.prototype, "getWebPropertyByProfileId", "getPropertyByViewId"), r.prototype.getAccountByWebPropertyId = function(t) {
    return this.webPropertiesById_[t] && this.webPropertiesById_[t].parent
  }, s(r.prototype, "getAccountByWebPropertyId", "getAccountByPropertyId"), t.exports = r
}]);
//# sourceMappingURL=view-selector2.js.map
