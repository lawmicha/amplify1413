

Sample app for https://github.com/aws-amplify/amplify-ios/issues/1413

## Set up

`amplify add api`

```

? Please select from one of the below mentioned services: GraphQL
? Provide API name: amplify1413
? Choose the default authorization type for the API Amazon Cognito User Pool
Use a Cognito user pool configured as a part of this project.
? Do you want to configure advanced settings for the GraphQL API Yes, I want to make some additional changes.
? Configure additional auth types? Yes
? Choose the additional authorization types you want to configure for the API IAM
? Enable conflict detection? No
? Do you have an annotated GraphQL schema? Yes
? Provide your schema file path: schema.graphql

```

2. `amplify push`

3. (Optional - can skip this step since the models should already be generated if using the sample project) `amplify codegen models`

4. `pod install`

5. Create the user via AWS CLI

```
aws cognito-idp admin-create-user --user-pool-id [POOL_ID] --username [USERNAME]
aws cognito-idp admin-set-user-password --user-pool-id [POOL_ID] --username [USERNAME] --password [PASSWORD] --permanent

```