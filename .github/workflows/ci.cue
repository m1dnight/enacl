let OTP_Versions = {
	latest: [24.0]
	all: [18.3, 19.3, 20.3, 21.3, 22.3, 23.3, 24.0]
	test: [20.3, 21.3]
}

name: "build"
on: {
	push: branches: [
		"master",
	]
	pull_request: branches: [
		"master",
	]
}
jobs: ci: {
	name:      "Run checks and tests over ${{matrix.otp_vsn}} and ${{matrix.os}}"
	"runs-on": "${{matrix.os}}"
	container: image: "erlang:${{matrix.otp_vsn}}"
	strategy: matrix: {
		otp_vsn: OTP_Versions.test
		os: ["ubuntu-latest"]
	}
	steps: [
		{uses: "actions/checkout@v2"},
		{name: "Update apt-get database",
		 run: "apt-get update"},
	    {name: "Install libsodium",
		 run: "apt-get install -y libsodium-dev"},
		{name: "Compile source code",
		 run: "make compile"},
		{name: "Run the tests",
		 run: "make tests"}]
}
