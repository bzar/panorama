.pragma library

function prettySizeValue(size) {
  var K = 1024;
  if(size < K) {
    return size;
  } else if(size < K*K) {
    return (size/K).toFixed();
  } else if(size < K*K*K) {
    return (size/(K*K)).toFixed();
  } else {
    return (size/(K*K*K)).toFixed();
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
  if(version === null) {
    return "N/A";
  }

  return version.major + "." + version.minor + "." + version.release + "." + version.build;
}

function prettyLastUpdatedString(datetime) {
  var now = (new Date()).getTime();
  var then = datetime.getTime();

  if(then === 0) {
      return "unknown";
  }

  var days = Math.floor((now - then) / (1000 * 60*60*24));

  if(days < 0) {
    return "recently";
  } else if(days === 0) {
    return "today";
  } else if(days === 1) {
    return "yesterday";
  } else if(days < 2*7) {
    return days + " days ago";
  } else if(days < 2*30) {
    return Math.floor(days/7) + " weeks ago";
  } else if(days < 2*365) {
     return Math.floor(days/30) + " months ago";
  } else {
    return Math.floor(days/365) + " years ago";
  }
}

function cropText(text, maxSize) {
  return text.length > maxSize ? text.slice(0, maxSize - 1) + "…" : text;
}
