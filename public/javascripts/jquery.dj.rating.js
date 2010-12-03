/*
 * jQuery Rating
 * http://plugins.jquery.com/...
 *
 * Copyright (c) 2010 David James
 * TODO: Figure out license
 * PERHAPS: http://docs.jquery.com/License
 *
 * Depends:
 *  jquery.ui.core.js
 *  jquery.ui.widget.js
 */

$.widget("dj.rating", {
  options: {
    // value: 0
  },
  _create: function() {
    this.element.addClass("rating_class");
    this._update();
  },
  _setOption: function(key, value) {
    this.options[key] = value;
    this._update();
  },
  _update: function() {
  },
  destroy: function() {
    this.element.removeClass("rating_class");
    $.Widget.prototype.destroy.call(this);
  }
});