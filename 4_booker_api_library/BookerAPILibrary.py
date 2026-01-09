from typing import Dict, List

from requests import Response, Session


class BookerAPILibrary(Session):
    auth_token: str = None
    base_url: str
    last_response: Response = None
    last_response_body: Dict = None

    def __init__(self, base_url: str, login_credentials: Dict = None):
        super().__init__()

        self.base_url = base_url

        if login_credentials:
            self.log_in(login_credentials)

    def send_request(
        self,
        method: str,
        endpoint: str,
        params=None,
        data=None,
        headers=None,
        cookies=None,
        files=None,
        auth=None,
        timeout=None,
        allow_redirects=True,
        proxies=None,
        hooks=None,
        stream=None,
        verify=None,
        cert=None,
        json=None,
    ):
        if not endpoint.startswith("/"):
            endpoint = "/" + endpoint

        url = f"{self.base_url}{endpoint}"

        # clear previous response body
        self.last_response_body = None

        # send the request and save the response
        self.last_response = self.request(
            method,
            url,
            params,
            data,
            headers,
            cookies,
            files,
            auth,
            timeout,
            allow_redirects,
            proxies,
            hooks,
            stream,
            verify,
            cert,
            json,
        )

        self.last_response.raise_for_status()

        # save and return the response body
        self.last_response_body = self.last_response.json()
        return self.last_response_body

    def create_token(self, payload: Dict):
        return self.send_request("POST", "auth", json=payload)

    def log_in(self, payload: Dict):
        self.create_token(payload)

        assert "token" in self.last_response_body, self.last_response_body["reason"]
        self.token = self.last_response_body["token"]
        self.headers.update({"Cookie": f"token={self.token}"})

        return self.last_response_body

    def get_booking_ids(self) -> List[Dict]:
        return self.send_request("GET", "/booking")

    def get_booking(self, booking_id) -> Dict:
        return self.send_request("GET", f"/booking/{booking_id}")

    def create_booking(self, payload) -> Dict:
        return self.send_request("POST", "/booking", json=payload)

    def update_booking(self, booking_id, payload) -> Dict:
        return self.send_request("PUT", f"/booking/{booking_id}", json=payload)

    def partial_update_booking(self, booking_id, payload) -> Dict:
        return self.send_request("PATCH", f"/booking/{booking_id}", json=payload)

    def response_should_not_be_empty(self):
        assert self.last_response_body is not None and len(self.last_response_body) > 0
