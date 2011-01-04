function() {
  var xs = this.distributions;
  if(xs) {
    xs.forEach(
      function(x) { emit(x.kind, 1); }
    );
  }
};
