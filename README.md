# How to load and the demo app

This is the most basic of all demo apps. It is designed for you to open up and build your own app on top of it. Engjoy. 

Please join us in our [Developer Community](https://community.dasha.ai).

1. Clone the repo and install the dependencies:

```sh
git clone https://github.com/dasha-samples/blank-slate-app
cd blank-slate-app
npm install
```

2. Create or log into your account using the Dasha CLI tool:

```sh
npx dasha account login
```

3. To start a text chat, run:

```sh
npm start chat
```

4. To receive a phone call from Dasha, run:

```sh
npm start <your phone number>
```

The phone number should be in the international format without the `+` (e.g. `12223334455`)
