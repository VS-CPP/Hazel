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


/// Main Function Copy and Pasted here from EntryPoint because Hazel.h file include EntryPoint.h file
// Therefor EntryPiont knows every header files which is accessable for SandboxApp.

/// Main function exist in EntryPoint, That file only launch the SandboxApp, but really Application is SandboxApp