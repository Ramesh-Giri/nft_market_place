const imageUrl = "assets/images/magCover.png";

enum Source { home, myNfts, profileCillectibles }

//Contract configurations
const contractAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
const url = "http://127.0.0.1:8545"; //rpc url
const wsUrl = "ws://127.0.0.1:8545"; //websocket url

const dummyAddress = "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc";
const dummyPrivateKey =
    "0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba";

const genesisAddress = "0x0000000000000000000000000000000000000000";

//Pinata configurations
const pinataUrl = "https://api.pinata.cloud";
const pinEndpoint = "/pinning/pinFileToIPFS";
const apiKey = "f83f67660f94493c49c5";
const apiSecret =
    "220f40e9f0e538ba2e04f09747057bdd679bbe849a56c64de6158dc1a96bcdfc";
const jwt =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiJlNTZhODJiNi1iYmY5LTRiNDgtYmViNy0wNTA4NzY1OGRjYjkiLCJlbWFpbCI6Im1vYnRlcmVzdEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJpZCI6IkZSQTEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX0seyJpZCI6Ik5ZQzEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlLCJzdGF0dXMiOiJBQ1RJVkUifSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiZjgzZjY3NjYwZjk0NDkzYzQ5YzUiLCJzY29wZWRLZXlTZWNyZXQiOiIyMjBmNDBlOWYwZTUzOGJhMmUwNGYwOTc0NzA1N2JkZDY3OWJiZTg0OWE1NmM2NGRlNjE1OGRjMWE5NmJjZGZjIiwiaWF0IjoxNjgwMTgzODc2fQ.Z8RDxTTFzDuMsEOMWpDWExXS8uAyy0OqqF15xeSnn_A";
const pinataGateway = "https://gateway.pinata.cloud/ipfs/";