#include "hzpch.h"
#include "Application.h"

#include "Hazel/Log.h"

#include <GLFW/glfw3.h>

namespace Hazel {

#define BIND_EVENT_FN(x) std::bind(&Application::x, this, std::placeholders::_1)

	Application::Application()
	{
		// its unique pointer so it must be store somewhere
		// without storage variable it's crushed
		m_Window = std::unique_ptr<Window>(Window::Create());
		m_Window->SetEventCallback(BIND_EVENT_FN(OnEvent));
	}
	
	Application::~Application()
	{
	
	}

	void Application::Run()
	{
		//WindowResizeEvent e(1200, 720);
		//HZ_TRACE(e);  // This macro is spdlog and I think spdlog in deep use cout <<
		               // and therefor Application file know bout Event file here it use operator <<
		               // and get result



		while (m_Runing)
		{
			glClearColor(1, 0, 1, 1);
			glClear(GL_COLOR_BUFFER_BIT);
			m_Window->OnUpdate();
		}

	}

	void Application::OnEvent(Event& e)
	{
		EventDispatcher dispatcher(e);
		dispatcher.Dispatch<WindowCloseEvent>(BIND_EVENT_FN(OnWindowClose));

		HZ_CORE_INFO("{0}", e);
	}

	bool Application::OnWindowClose(WindowCloseEvent& e)
	{
		m_Runing = false;
		return true;
	}

}
