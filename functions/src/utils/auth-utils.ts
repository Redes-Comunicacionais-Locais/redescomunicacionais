import { CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { User } from "../model/User";

type AuthData = CallableRequest['auth'];

function isAuthenticated(authData?: AuthData): void {
  if (!authData || !authData.token) {
    throw new HttpsError("unauthenticated", "User is not authenticated.");
  }
}

export function getLoggedUser(authData?: AuthData): User {
  isAuthenticated(authData);

  const email = authData!.token.email;
  if (email === null || email === undefined || email.trim() === "") {
    throw new HttpsError("unauthenticated", "Invalid email.");
  }

  return {
    uid: authData!.uid,
    email: email
    //role: authData.token.role
  };
}