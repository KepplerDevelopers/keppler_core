! function(t) {
  function e(s) {
    if (i[s]) return i[s].exports;
    var r = i[s] = {
      exports: {},
      id: s,
      loaded: !1
    };
    return t[s].call(r.exports, r, r.exports, e), r.loaded = !0, r.exports
  }
  var i = {};
  return e.m = t, e.c = i, e.p = "", e(0)
}([function(t, e, i) {
  "use strict";
  gapi.analytics.ready(function() {
    gapi.analytics.createComponent("ActiveUsers", {
      initialize: function() {
        this.activeUsers = 0
      },
      execute: function() {
        this.polling_ && this.stop(), this.render_(), gapi.analytics.auth.isAuthorized() ? this.getActiveUsers_() : gapi.analytics.auth.once("success", this.getActiveUsers_.bind(this))
      },
      stop: function() {
        clearTimeout(this.timeout_), this.polling_ = !1, this.emit("stop", {
          activeUsers: this.activeUsers
        })
      },
      render_: function() {
        var t = this.get();
        this.container = "string" == typeof t.container ? document.getElementById(t.container) : t.container, this.container.innerHTML = t.template || this.template, this.container.querySelector("b").innerHTML = this.activeUsers
      },
      getActiveUsers_: function() {
        var t = this.get(),
          e = 1e3 * (t.pollingInterval || 5);
        if (isNaN(e) || 5e3 > e) throw new Error("Frequency must be 5 seconds or more.");
        this.polling_ = !0, gapi.client.analytics.data.realtime.get({
          ids: t.ids,
          metrics: "rt:activeUsers"
        }).execute(function(t) {
          var i = t.totalResults ? +t.rows[0][0] : 0,
            s = this.activeUsers;
          this.emit("success", {
            activeUsers: this.activeUsers
          }), i != s && (this.activeUsers = i, this.onChange_(i - s)), (this.polling_ = !0) && (this.timeout_ = setTimeout(this.getActiveUsers_.bind(this), e))
        }.bind(this))
      },
      onChange_: function(t) {
        var e = this.container.querySelector("b");
        e && (e.innerHTML = this.activeUsers), this.emit("change", {
          activeUsers: this.activeUsers,
          delta: t
        }), t > 0 ? this.emit("increase", {
          activeUsers: this.activeUsers,
          delta: t
        }) : this.emit("decrease", {
          activeUsers: this.activeUsers,
          delta: t
        })
      },
      template: '<div class="ActiveUsers">Usuarios activos: <b class="ActiveUsers-value"></b></div>'
    })
  })
}]);
//# sourceMappingURL=active-users.js.map