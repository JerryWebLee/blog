const testObject = {
  name: 'test',
  value: 123,
  items: [1, 2, 3, 4, 5],
}

function testFunction() {
  const message = 'Hello ' + testObject.name
  return message
}

module.exports = { testObject, testFunction }
