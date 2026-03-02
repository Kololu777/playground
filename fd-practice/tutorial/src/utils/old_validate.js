/**
 * Legacy validation utilities
 * @deprecated Use a proper validation library
 */

function isEmail(value) {
  var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(value);
}

function isUrl(value) {
  try {
    new URL(value);
    return true;
  } catch (e) {
    return false;
  }
}

function isNonEmpty(value) {
  return typeof value === "string" && value.trim().length > 0;
}

module.exports = { isEmail, isUrl, isNonEmpty };
