const translations = window.money.translations;
const i18n = {};

const format = (string, { locals }) => {
  Object.entries(locals).forEach(([key, value]) => {
    string = string.replace(`{{${key}}}`, value);
  });

  return string;
};

const valueFor = (key) =>
  key.split(".").reduce((acc, el) => acc && acc[el], translations);

i18n.t = (key, values = {}, { scope = "" }) => {
  if (scope) key = `${scope}.${key}`;

  if (values.count !== undefined) {
    if (values.count === 0 && valueFor(`${key}.zero`)) {
      key = `${key}.zero`;
    } else if (values.count === 1 && valueFor(`${key}.one`)) {
      key = `${key}.one`;
    } else {
      key = `${key}.other`;
    }
  }

  const value = valueFor(key);

  if (!value) return `[missing translation for ${key}]`;

  if (typeof value !== "string") {
    return JSON.stringify({ key, values });
  }

  return format(value, { locals: values });
};

i18n.scope = (name) => {
  return (key, value) => {
    return i18n.t(key, value, { scope: name });
  };
};

export default i18n;
