# Newton iOS SDK

Swift SDK to work with Newton services

## Table of Contents

- [Newton Auth](#newton-auth)
- [Author](#author)

## Newton Auth

SDK to integrate login with Newton authentication service based on Keycloak

#### Getting started

1. import newton authentication

```swift
import NewtonAuth
```

2. request phone code to start authentication flow
```swift
let newtonAuth = NewtonAuth.authentication(
    url: "NEWTON_AUTH_URL", // Newton auth server url
    clientId: "NEWTON_AUTH_CLIENT_ID", // Newton auth client id
    realm: "main", // main realm name
    serviceRealm: "service" // service realm name
)

newtonAuth
    .sendPhoneCode(
        phoneNumber: "+79...", // user phone number
        onSuccess: { result, flowState in
            print(result.accessToken) // service token
        },
        onError: { error in
            print(error.error) // authentication error
        }
    )
```

3. verify phone code with service token from previous step

```swift
newtonAuth
    .verifyPhone(
        withCode: "12345", // code
        serviceToken: "SERVICE_TOKEN", // service token received from previous step
        onSuccess: { result, flowState in
            print(result.accessToken) // service token
        },
        onError: { error in
            print(error.error) // authentication error
        }
    )
```

4. sign in with service token from previous step and get access token and refresh token
```swift
newtonAuth
    .login(
        withServiceToken: "SERVICE_TOKEN", // service token received from previous step
        onSuccess: { result in
            print(result.accessToken) // access token
            print(result.refreshToken) // refresh token
        },
        onError: { error in
            print(error.error) // authentication error
        }
    )
```

or if user signs in with password

```swift
newtonAuth
    .login(
        withServiceToken: "SERVICE_TOKEN", // service token received from previous step
        password: "PASSWORD", // user password
        onSuccess: { result in
            print(result.accessToken) // access token
            print(result.refreshToken) // refresh token
        },
        onError: { error in
            print(error.error) // authentication error
        }
    )
```

5. get new access token with refresh token
```swift
newtonAuth
    .refreshToken(
        refreshToken: "REFRESH_TOKEN",
        onSuccess: { result in
            print(result.accessToken) // access token
            print(result.refreshToken) // refresh token
        },
        onError: { error in
            print(error.error) // authentication error
        }
    )
```

## Author

[Newton](https://nwtn.io/)
