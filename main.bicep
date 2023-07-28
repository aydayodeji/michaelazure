targetScope = 'subscription'

var policyName = 'Created Date Policy'
var policyDisplayName = 'Created Date Policy'
var policyDescription = 'This policy applies a created on date on new azure resources'

resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyName
  properties: {
    displayName: policyDisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Tags'
    }

    policyRule: {
      if: {
        allOf: [
          {
            field: 'tags["createdDate"]'
            exists: false
          }
        ]
      }
      then: {
        // The action to apply the "createdDateTime" tag
        effect: 'append'
        details: {
          // Specify the "createdDateTime" tag and its value
          message: 'The "createdDateTime" tag is applied.'
          roleDefinitionIds: []
          operations: [
            {
              operation: 'add'
              field: 'tags["createdDate"]'
              value: '[utcNow()]'
            }
          ]
        }
      }
    }
  }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyName
  properties: {
    policyDefinitionId: policy.id
    displayName: 'Apply created tag on resources'
    description: 'Policy will apply created date on resources'
  }
}
