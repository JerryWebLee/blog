const test = {
  name: 'test',
  value: 123,
  items: [1, 2, 3, 4, 5],
}

function formatTest() {
  return test.name + ' ' + test.value
}

module.exports = { test, formatTest }
