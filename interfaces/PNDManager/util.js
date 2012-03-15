.pragma library

function prettySizeValue(size) {
  var K = 1024;
  if(size < K) {
    return size;
  } else if(size < K*K) {
    return (size/K).toFixed(2);
  } else if(size < K*K*K) {
    return (size/(K*K)).toFixed(2);
  } else {
    return (size/(K*K*K)).toFixed(2);
  }
}

function prettySizeUnit(size) {
  var K = 1024;
  if(size < K) {
    return "B";
  } else if(size < K*K) {
    return "KiB";
  } else if(size < K*K*K) {
    return "MiB";
  } else {
    return "GiB";
  }
}

function prettyProgress(value, size) {
  var K = 1024;
  if(size < K) {
    return {value: value, size: size, unit: "B"};
  } else if(size < K*K) {
    return {value: (value/K).toFixed(2), size: (size/K).toFixed(2), unit: "KiB"};
  } else if(size < K*K*K) {
    return {value: (value/(K*K)).toFixed(2), size: (size/(K*K)).toFixed(2), unit: "MiB"};
  } else {
    return {value: (value/(K*K*K)).toFixed(2), size: (size/(K*K*K)).toFixed(2), unit: "GiB"};
  }
}

function prettySize(size) {
  return prettySizeValue(size) + " " + prettySizeUnit(size);
}

function versionString(version) {
  return version.major + "." + version.minor + "." + version.release + "." + version.build;
}
