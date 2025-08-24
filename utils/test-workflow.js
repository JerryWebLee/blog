// 测试 ESLint 和 Prettier 协作
const testData = {
  name: 'test',
  items: [1, 2, 3, 4, 5],
  config: {
    enabled: true,
    timeout: 5000,
  },
}

function processData(data) {
  const result = `Processing ${data.name} with ${data.items.length} items`
  return result
}

const output = processData(testData)
console.log(output)
