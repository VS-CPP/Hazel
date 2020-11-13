#include <Hazel.h>

class Sandbox : public Hazel::Application
{
public:
	Sandbox()
	{

	}

	~Sandbox()
	{

	}

};

Hazel::Application* Hazel::CreateApplication()
{
	return new Sandbox();
}


/// Main Function Copy and Pasted here from EntryPoint
// Therefor EntryPiont knows every header files which is accessable for SandboxApp.