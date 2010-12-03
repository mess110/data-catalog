function(key, values) {
  var total = 0;
  values.forEach(
    function(x) { total += x; }
  );
  return total;
};
