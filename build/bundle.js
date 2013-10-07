;(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var coffeeshop;

  coffeeshop = require("./module.coffee");

}).call(this);


},{"./module.coffee":2}],2:[function(require,module,exports){
(function() {
  var coffeeshop;

  module.exports = coffeeshop = angular.module("coffeeshop", []);

  require("./storage/service.coffee");

  require("./products/list/controller.coffee");

}).call(this);


},{"./products/list/controller.coffee":3,"./storage/service.coffee":4}],3:[function(require,module,exports){
(function() {
  angular.module('coffeeshop').controller("productList", function($scope, storage) {
    var save, watchExp;
    $scope.products = [];
    watchExp = function(entity) {
      var lastModified;
      lastModified = 0;
      entity.on('modified', function() {
        return lastModified = new Date / 1e3;
      });
      return function() {
        return lastModified;
      };
    };
    save = function(newV, oldV) {
      return storage.save();
    };
    storage.ready.then(function(products) {
      console.log("then", products);
      return $scope.products = products;
    });
    storage.ready["catch"](function(e) {
      return console.log("error", e);
    });
    return storage.ready["finally"](function(e) {
      return console.log("finally", e);
    });
  });

}).call(this);


},{}],4:[function(require,module,exports){
(function() {
  angular.module('coffeeshop').service("storage", function($location, $q, $rootScope) {
    var base, loading, products, runtime, storage;
    products = null;
    base = "" + ($location.protocol()) + "://" + ($location.host()) + ":" + ($location.port()) + "/";
    runtime = new JEFRi.Runtime("" + base + "context.json");
    loading = $q.defer();
    storage = {
      get: function() {},
      save: function() {},
      runtime: runtime,
      ready: loading.promise
    };
    runtime.ready.then(function() {
      var s, t;
      t = new window.JEFRi.Transaction();
      t.add({
        _type: 'Product'
      });
      s = new window.JEFRi.Stores.PostStore({
        remote: base,
        runtime: runtime
      });
      return s.execute('get', t).then(function(list) {
        if (list.entities.length) {
          runtime.expand(list.entities);
          return products = runtime.find('Product');
        } else {
          throw new Exception('Product not found.');
        }
      })["catch"](function(e) {
        return products = [
          runtime.build('Product', {
            'name': 'Product Name'
          })
        ];
      })["finally"](function() {
        storage.get = function() {
          return products;
        };
        storage.save = function() {
          var product, _i, _len;
          t = new window.JEFRi.Transaction();
          for (_i = 0, _len = products.length; _i < _len; _i++) {
            product = products[_i];
            t.add(product);
          }
          s = new window.JEFRi.Stores.PostStore({
            remote: base,
            runtime: runtime
          });
          return s.execute('persist', t);
        };
        loading.resolve(products);
        return $rootScope.$digest();
      });
    })["catch"](function(e) {
      console.error("Couldn't load context!");
      return console.error(e.message, e);
    });
    return storage;
  });

}).call(this);


},{}]},{},[1])
//@ sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvaG9tZS9wb3J0YWovZGV2ZWwvc2kvY29mZmVlc2hvcC9zcmMvY2xpZW50L21haW4uY29mZmVlIiwiL2hvbWUvcG9ydGFqL2RldmVsL3NpL2NvZmZlZXNob3Avc3JjL2NsaWVudC9tb2R1bGUuY29mZmVlIiwiL2hvbWUvcG9ydGFqL2RldmVsL3NpL2NvZmZlZXNob3Avc3JjL2NsaWVudC9wcm9kdWN0cy9saXN0L2NvbnRyb2xsZXIuY29mZmVlIiwiL2hvbWUvcG9ydGFqL2RldmVsL3NpL2NvZmZlZXNob3Avc3JjL2NsaWVudC9zdG9yYWdlL3NlcnZpY2UuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7QUFBQTtDQUFBLEtBQUEsSUFBQTs7Q0FBQSxDQUFBLENBQWEsSUFBQSxHQUFiLE9BQWE7Q0FBYjs7Ozs7QUNBQTtDQUFBLEtBQUEsSUFBQTs7Q0FBQSxDQUFBLENBQWlCLEdBQVgsQ0FBTixHQUFpQixFQUFhOztDQUE5QixDQUVBLEtBQUEsbUJBQUE7O0NBRkEsQ0FHQSxLQUFBLDRCQUFBO0NBSEE7Ozs7O0FDQUE7Q0FBQSxDQUFBLENBQXVELEdBQXZELENBQU8sRUFBaUQsQ0FBeEQsRUFBQSxDQUFBO0NBQ0MsT0FBQSxNQUFBO0NBQUEsQ0FBQSxDQUFrQixDQUFsQixFQUFNLEVBQU47Q0FBQSxFQUVXLENBQVgsRUFBVyxFQUFYLENBQVk7Q0FDWCxTQUFBLEVBQUE7Q0FBQSxFQUFlLEdBQWYsTUFBQTtDQUFBLENBQ0EsQ0FBc0IsR0FBdEIsR0FBc0IsQ0FBdEI7QUFDZ0IsQ0FBQSxFQUFBLENBQUEsUUFBZixHQUFBO0NBREQsTUFBc0I7R0FFdEIsTUFBQSxJQUFBO0NBQUEsY0FBRztDQUpPLE1BSVY7Q0FORCxJQUVXO0NBRlgsQ0FRYyxDQUFQLENBQVAsS0FBUTtDQUNDLEdBQVIsR0FBTyxNQUFQO0NBVEQsSUFRTztDQVJQLEVBVW1CLENBQW5CLENBQWEsRUFBTixDQUFZLENBQUM7Q0FDbkIsQ0FBb0IsQ0FBcEIsR0FBQSxDQUFPLENBQVA7Q0FDTyxFQUFXLEdBQVosRUFBTixLQUFBO0NBRkQsSUFBbUI7Q0FWbkIsRUFnQm9CLENBQXBCLENBQWEsRUFBTixFQUFjO0NBQ1osQ0FBYSxDQUFyQixJQUFPLE1BQVA7Q0FERCxJQUFvQjtDQUdaLEVBQWMsRUFBVCxFQUFOLEVBQU0sRUFBYjtDQUNTLENBQWUsQ0FBdkIsSUFBTyxFQUFQLElBQUE7Q0FERCxJQUFzQjtDQXBCdkIsRUFBdUQ7Q0FBdkQ7Ozs7O0FDQUE7Q0FBQSxDQUFBLENBQWdELEdBQWhELENBQU8sRUFBUCxDQUFnRCxFQUFoRDtDQUNDLE9BQUEsaUNBQUE7Q0FBQSxFQUFXLENBQVgsSUFBQTtDQUFBLENBRU8sQ0FBQSxDQUFQLENBQU8sR0FBRSxDQUFTO0NBRmxCLENBRzRCLENBQWQsQ0FBZCxDQUFtQixFQUFuQixPQUFjO0NBSGQsQ0FJWSxDQUFGLENBQVYsQ0FBVSxFQUFWO0NBSkEsRUFPQyxDQURELEdBQUE7Q0FDQyxDQUFLLENBQUwsR0FBQSxHQUFLO0NBQUwsQ0FDTSxDQUFBLENBQU4sRUFBQSxHQUFNO0NBRE4sQ0FFUyxJQUFULENBQUE7Q0FGQSxDQUdPLEdBQVAsQ0FBQSxDQUFjO0NBVmYsS0FBQTtDQUFBLEVBWW1CLENBQW5CLENBQWEsRUFBTixFQUFZO0NBQ2xCLEdBQUEsTUFBQTtDQUFBLEVBQVEsQ0FBQSxDQUFZLENBQXBCLEtBQVE7Q0FBUixFQUNBLEdBQUE7Q0FBTSxDQUFPLEdBQVAsR0FBQSxDQUFBO0NBRE4sT0FDQTtDQURBLEVBRVEsQ0FBQSxDQUFZLENBQXBCLEdBQVE7Q0FBOEIsQ0FBUyxFQUFULEVBQUMsRUFBQTtDQUFELENBQWUsS0FBZixDQUFlO0NBRnJELE9BRVE7Q0FFUCxDQUFnQixDQUNYLENBRE4sQ0FBQSxFQUFBLEVBQ08sSUFEUDtDQUVDLEdBQUcsRUFBSCxFQUFBO0NBQ0MsR0FBbUIsRUFBbkIsQ0FBTyxDQUFQLEVBQUE7Q0FDbUIsRUFBUixDQUFBLEdBQU8sQ0FBbEIsQ0FBVyxRQUFYO01BRkQsSUFBQTtDQUlDLEdBQVUsS0FBQSxPQUFBLElBQUE7VUFMTjtDQUROLEVBT08sSUFORCxFQU1FO0dBQ0ksS0FBWCxPQUFBO0NBQW9CLENBQWlCLEdBQXpCLEVBQU8sRUFBUCxFQUFBO0NBQXlCLENBQVEsSUFBUCxNQUFBLEVBQUQ7Q0FBMUIsV0FBQztDQUROO0NBUFAsRUFTUyxJQUZGLEVBRVA7Q0FDQyxFQUFBLElBQU8sQ0FBUCxDQUFjO0NBQUEsZ0JBQUc7Q0FBakIsUUFBYztDQUFkLEVBQ2UsQ0FBZixHQUFPLENBQVAsQ0FBZTtDQUNkLGFBQUEsR0FBQTtDQUFBLEVBQVEsQ0FBQSxDQUFZLENBQU4sSUFBZCxDQUFRO0FBQ1IsQ0FBQSxjQUFBLGdDQUFBO29DQUFBO0NBQUEsRUFBQSxJQUFBLEtBQUE7Q0FBQSxVQURBO0NBQUEsRUFFUSxDQUFBLENBQVksQ0FBTixHQUFOLENBQVI7Q0FBc0MsQ0FBUyxFQUFULEVBQUMsTUFBQTtDQUFELENBQWUsS0FBZixLQUFlO0NBRnJELFdBRVE7Q0FDUCxDQUFvQixLQUFyQixFQUFBLFFBQUE7Q0FMRCxRQUNlO0NBRGYsTUFPTyxDQUFQO0NBQ1csTUFBWCxHQUFVLEtBQVY7Q0FsQkQsTUFTUztDQWRWLEVBeUJPLEVBekJZLEVBeUJuQixFQUFRO0NBQ1AsSUFBQSxDQUFBLENBQU8saUJBQVA7Q0FDUSxDQUFpQixHQUF6QixFQUFPLE1BQVA7Q0EzQkQsSUF5Qk87Q0F0Q3dDLFVBeUMvQztDQXpDRCxFQUFnRDtDQUFoRCIsInNvdXJjZXNDb250ZW50IjpbImNvZmZlZXNob3AgPSByZXF1aXJlIFwiLi9tb2R1bGUuY29mZmVlXCJcbiIsIm1vZHVsZS5leHBvcnRzID0gY29mZmVlc2hvcCA9IGFuZ3VsYXIubW9kdWxlIFwiY29mZmVlc2hvcFwiLCBbXVxuXG5yZXF1aXJlIFwiLi9zdG9yYWdlL3NlcnZpY2UuY29mZmVlXCJcbnJlcXVpcmUgXCIuL3Byb2R1Y3RzL2xpc3QvY29udHJvbGxlci5jb2ZmZWVcIlxuIiwiYW5ndWxhci5tb2R1bGUoJ2NvZmZlZXNob3AnKS5jb250cm9sbGVyIFwicHJvZHVjdExpc3RcIiwgKCRzY29wZSwgc3RvcmFnZSktPlxuXHQkc2NvcGUucHJvZHVjdHMgPSBbXVxuXG5cdHdhdGNoRXhwID0gKGVudGl0eSktPlxuXHRcdGxhc3RNb2RpZmllZCA9IDBcblx0XHRlbnRpdHkub24gJ21vZGlmaWVkJywgLT5cblx0XHRcdGxhc3RNb2RpZmllZCA9IG5ldyBEYXRlIC8gMWUzXG5cdFx0LT4gbGFzdE1vZGlmaWVkXG5cblx0c2F2ZSA9IChuZXdWLCBvbGRWKSAtPlxuXHRcdHN0b3JhZ2Uuc2F2ZSgpXG5cdHN0b3JhZ2UucmVhZHkudGhlbiAocHJvZHVjdHMpLT5cblx0XHRjb25zb2xlLmxvZyBcInRoZW5cIiwgcHJvZHVjdHNcblx0XHQkc2NvcGUucHJvZHVjdHMgPSBwcm9kdWN0c1xuXHRcdCMkc2NvcGUuJHdhdGNoIHdhdGNoRXhwKGxpc3QpLCBzYXZlLCB0cnVlXG5cdFx0IyRzY29wZS4kd2F0Y2ggXCJsaXN0Ll9zdGF0dXMoKSAhPSAnUEVSU0lTVEVEJ1wiLCBzYXZlLCB0cnVlXG5cblx0c3RvcmFnZS5yZWFkeS5jYXRjaCAoZSktPlxuXHRcdGNvbnNvbGUubG9nIFwiZXJyb3JcIiwgZVxuXG5cdHN0b3JhZ2UucmVhZHkuZmluYWxseSAoZSktPlxuXHRcdGNvbnNvbGUubG9nIFwiZmluYWxseVwiLCBlXG4iLCJhbmd1bGFyLm1vZHVsZSgnY29mZmVlc2hvcCcpLnNlcnZpY2UgXCJzdG9yYWdlXCIsICgkbG9jYXRpb24sICRxLCAkcm9vdFNjb3BlKS0+XG5cdHByb2R1Y3RzID0gbnVsbFxuXG5cdGJhc2UgPSBcIiN7JGxvY2F0aW9uLnByb3RvY29sKCl9Oi8vI3skbG9jYXRpb24uaG9zdCgpfTojeyRsb2NhdGlvbi5wb3J0KCl9L1wiXG5cdHJ1bnRpbWUgPSBuZXcgSkVGUmkuUnVudGltZSBcIiN7YmFzZX1jb250ZXh0Lmpzb25cIlxuXHRsb2FkaW5nID0gJHEuZGVmZXIoKVxuXG5cdHN0b3JhZ2UgPVxuXHRcdGdldDogLT5cblx0XHRzYXZlOiAtPlxuXHRcdHJ1bnRpbWU6IHJ1bnRpbWVcblx0XHRyZWFkeTogbG9hZGluZy5wcm9taXNlXG5cblx0cnVudGltZS5yZWFkeS50aGVuIC0+XG5cdFx0dCA9IG5ldyB3aW5kb3cuSkVGUmkuVHJhbnNhY3Rpb24oKVxuXHRcdHQuYWRkIF90eXBlOiAnUHJvZHVjdCdcblx0XHRzID0gbmV3IHdpbmRvdy5KRUZSaS5TdG9yZXMuUG9zdFN0b3JlKHtyZW1vdGU6IGJhc2UsIHJ1bnRpbWV9KVxuXG5cdFx0cy5leGVjdXRlKCdnZXQnLCB0KVxuXHRcdC50aGVuIChsaXN0KS0+XG5cdFx0XHRpZiBsaXN0LmVudGl0aWVzLmxlbmd0aFxuXHRcdFx0XHRydW50aW1lLmV4cGFuZCBsaXN0LmVudGl0aWVzXG5cdFx0XHRcdHByb2R1Y3RzID0gcnVudGltZS5maW5kKCdQcm9kdWN0Jylcblx0XHRcdGVsc2Vcblx0XHRcdFx0dGhyb3cgbmV3IEV4Y2VwdGlvbiAnUHJvZHVjdCBub3QgZm91bmQuJ1xuXHRcdC5jYXRjaCAoZSktPlxuXHRcdFx0cHJvZHVjdHMgPSBbcnVudGltZS5idWlsZCgnUHJvZHVjdCcsIHsnbmFtZSc6J1Byb2R1Y3QgTmFtZSd9KV1cblx0XHQuZmluYWxseSAtPlxuXHRcdFx0c3RvcmFnZS5nZXQgPSAtPiBwcm9kdWN0c1xuXHRcdFx0c3RvcmFnZS5zYXZlID0gLT5cblx0XHRcdFx0dCA9IG5ldyB3aW5kb3cuSkVGUmkuVHJhbnNhY3Rpb24oKVxuXHRcdFx0XHR0LmFkZCBwcm9kdWN0IGZvciBwcm9kdWN0IGluIHByb2R1Y3RzXG5cdFx0XHRcdHMgPSBuZXcgd2luZG93LkpFRlJpLlN0b3Jlcy5Qb3N0U3RvcmUoe3JlbW90ZTogYmFzZSwgcnVudGltZX0pXG5cdFx0XHRcdHMuZXhlY3V0ZSAncGVyc2lzdCcsIHRcblxuXHRcdFx0bG9hZGluZy5yZXNvbHZlIHByb2R1Y3RzICMgV2h5IGRvZXNuJ3QgcmVzb2x2aW5nICRxIHRyaWdnZXIgYSBkaWdlc3Q/XG5cdFx0XHQkcm9vdFNjb3BlLiRkaWdlc3QoKVxuXHRcdFx0XG5cdC5jYXRjaCAoZSktPlxuXHRcdGNvbnNvbGUuZXJyb3IgXCJDb3VsZG4ndCBsb2FkIGNvbnRleHQhXCJcblx0XHRjb25zb2xlLmVycm9yIGUubWVzc2FnZSwgZVxuXHRzdG9yYWdlXG4iXX0=
;