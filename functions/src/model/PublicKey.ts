import * as admin from "firebase-admin";

export interface PublicKey {
  id: string;
  email: string;
  cities: string[];
  publicKey: string;
  oldPublicKeys: string[];
  createdAt: Date;
  lastUpdated: Date;
}

export interface PublicKeyJson extends Omit<PublicKey, 'createdAt' | 'lastUpdated'> {
  createdAt: string;
  lastUpdated: string;
}

export function firestoreToPublicKey(id: string, data: any): PublicKey {
  return {
    id: id,
    email: data.email || "",
    cities: data.cities || [],
    publicKey: data.publicKey || "",
    oldPublicKeys: data.oldPublicKeys || [],
    createdAt: data.createdAt.toDate(),
    lastUpdated: data.lastUpdated.toDate()
  };
}

export function publicKeyToFirestore(data: PublicKey): any {
  return {
    id: data.id,
    email: data.email,
    cities: data.cities || [],
    publicKey: data.publicKey,
    oldPublicKeys: data.oldPublicKeys || [],
    createdAt: data.createdAt
      ? admin.firestore.Timestamp.fromDate(data.createdAt)
      : admin.firestore.FieldValue.serverTimestamp(),
    lastUpdated: data.lastUpdated
      ? admin.firestore.Timestamp.fromDate(data.lastUpdated)
      : admin.firestore.FieldValue.serverTimestamp(),
  };
}

export function publicKeyToJson(data: PublicKey): PublicKeyJson {
  return {
    ...data,
    cities: data.cities || [],
    oldPublicKeys: data.oldPublicKeys || [],
    createdAt: data.createdAt.toISOString() ,
    lastUpdated: data.lastUpdated.toISOString(),
  };
}

export function jsonToPublicKey(data: any): PublicKey {
  return {
    id: data.id,
    email: data.email,
    cities: data.cities || [],
    publicKey: data.publicKey,
    oldPublicKeys: data.oldPublicKeys || [],
    createdAt: data.createdAt
      ? new Date(data.createdAt)
      : new Date(),
    lastUpdated: data.lastUpdated
      ? new Date(data.lastUpdated)
      : new Date(),
  };
}