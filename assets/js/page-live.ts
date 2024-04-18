import { MAINNET } from "kujira.js/src/network";
import { Sonar } from "kujira.js/src/wallets/sonar";

const SonarConnect = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      const sonarRequest = (uri: string) => {
        this.pushEvent("sonar-connect-request", { uri });
      };

      const onChange = (v: Sonar | null) => {
        console.log({ v });

        if (v) {
          this.pushEvent("sonar-connect-response", {
            address: v.account.address,
          });
        } else {
          this.pushEvent("sonar-disconnect", {});
        }
      };

      Sonar.connect(MAINNET, { request: sonarRequest, auto: false }).then(
        (x) => {
          this.pushEvent("sonar-connect-response", {
            address: x.account.address,
          });
          x.onChange(onChange);
          window.sonar = x;
        }
      );
    });
  },
};

const SonarDisconnect = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      window.sonar?.disconnect();
      this.pushEvent("sonar-disconnect", {});
    });
  },
};

export const hooks = { SonarConnect, SonarDisconnect };
