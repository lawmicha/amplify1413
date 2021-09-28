

Sample app for https://github.com/aws-amplify/amplify-ios/issues/1337

## Set up

`amplify add api`

```
base) 3c22fb653cb0:amplify1413 mdlaw$ amplify add api
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
App not deployed yet.

GraphQL schema compiled successfully.

Edit your schema at /Users/mdlaw/temp/amplify1413/amplify/backend/api/amplify1413/schema.graphql or place .graphql files in a directory at /Users/mdlaw/temp/amplify1413/amplify/backend/api/amplify1413/schema
Successfully added resource amplify1413 locally

Some next steps:
"amplify push" will build all your local backend resources and provision it in the cloud
"amplify publish" will build all your local backend and frontend resources (if you have hosting category added) and provision it in the cloud

```

2. `amplify push`

3. (Optional - can skip this step since the models should already be generated if using the sample project) `amplify codegen models`

4. `pod install`

5. Create the user via AWS CLI

```
aws cognito-idp admin-create-user --user-pool-id [POOL_ID] --username [USERNAME]
aws cognito-idp admin-set-user-password --user-pool-id [POOL_ID] --username [USERNAME] --password [PASSWORD] --permanent

```# amplify1337
# amplify1413
