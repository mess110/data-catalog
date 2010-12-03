function() {
  var xs = this.data_representations;
  if(xs) {
    xs.forEach(
      function(x) { emit(x.kind, 1); }
    );
  }
};
