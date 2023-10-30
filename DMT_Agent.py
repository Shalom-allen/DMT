import psutil
import matplotlib.pyplot as plt
import time

# CPU 사용량 모니터링 
def monito_cpu(interval):
    cpu_percentages = []
    timestamps = []
    
    while True:
        cpu_percent = psutil.cpu_percent()
        timestamp = time.time()
        
        cpu_percentages.append(cpu_percent)
        timestamps.append(timestamp)
        
        plt.plot(timestamps, cpu_percentages)
        plt.xlable("Time")
        plt.ylabel("CPU Usage Monitor")
        plt.title("CPU Usage Monitor")
        plt.grid(True)
        plt.pause(interval)
        
        
        