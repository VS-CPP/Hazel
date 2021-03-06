#include "hzpch.h"
#include "Application.h"

#include "Hazel/Log.h"

#include "glad/glad.h"
#include <GLFW/glfw3.h>

namespace Hazel {

#define BIND_EVENT_FN(x) std::bind(&Application::x, this, std::placeholders::_1)

	Application* Application::s_Instance = nullptr;

	Application::Application()
	{
		HZ_CORE_ASSERT(!s_Instance, "Application already exist!");
		s_Instance = this;

		// its unique pointer so it must be store somewhere
		// without storage variable it's crushed
		m_Window = std::unique_ptr<Window>(Window::Create());
		m_Window->SetEventCallback(BIND_EVENT_FN(OnEvent));

		/*unsigned int id;
		glGenVertexArrays(1, &id);*/
	}
	
	Application::~Application()
	{
	
	}

	void Application::PushLayer(Layer* layer)
	{
		m_LayerStack.PushLayer(layer);
		layer->OnAttach();
	}

	void Application::PushOverlay(Layer* overlay)
	{
		m_LayerStack.PushOverlay(overlay);
		overlay->OnAttach();
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

			// This declaration works because
			// In LayerStack class we implemented
			// begin() and end() iterator functions
			for (Layer* layer : m_LayerStack)
				layer->OnUpdate();
			
			
			m_Window->OnUpdate();
		}

	}

	void Application::OnEvent(Event& e)
	{
		EventDispatcher dispatcher(e);
		dispatcher.Dispatch<WindowCloseEvent>(BIND_EVENT_FN(OnWindowClose));

		HZ_CORE_INFO("{0}", e);

		for (auto it = m_LayerStack.end(); it != m_LayerStack.begin(); )
		{
			(*--it)->OnEvent(e);
			if (e.m_Handled)
				break;
		}
	}

	bool Application::OnWindowClose(WindowCloseEvent& e)
	{
		m_Runing = false;
		return true;
	}

}
