import { PublicKey } from "./PublicKey";

export interface KeysPackage {
  publicKeys: PublicKey[];
  sender: string;
  timestamp: Date;
  signature: string;
}