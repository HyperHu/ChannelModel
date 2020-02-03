import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d as Axes3D

def CalNonameCurve(rhoList, sigma, N):
    tmpV = np.multiply(rhoList, rhoList)
    theCurve = np.divide(sigma * rhoList, np.exp(0.5 * tmpV))
    theCurve = np.power(theCurve, N)
    theCurve = sigma * theCurve
    theCurve = theCurve / np.sum(theCurve)
    return theCurve

def CalTheCurve(rhoList, P, N):
    theCurve = np.multiply(rhoList, np.exp(-np.power(rhoList, 2.0) / (2.0 * P)))
    theCurve = np.power(theCurve, N)
    #theCurve = np.multiply(theCurve, abs(rhoList[1] - rhoList[0]))
    theCurve = theCurve / np.sum(theCurve)
    theCumulateCurve = np.zeros_like(theCurve)
    for idx in range(1, len(rhoList)):
        theCumulateCurve[idx] = theCumulateCurve[idx - 1] + theCurve[idx]
    return theCurve, theCumulateCurve

def CalCurve_dB(snrdB, B, C):
    tmpV = B * np.power(10, -snrdB/10)
    theCurve = np.exp(tmpV + -snrdB)
    theCurve = np.power(theCurve, C)
    theCurve = theCurve / np.max(theCurve)
    x0 = 10.0 * np.log10(-10.0 / (B * np.log(10.0)))
    return theCurve, x0

if __name__ == "__main__":
    B = -1.0
    C = 1.0
    theSnr_dB = np.arange(-15.0, 30.0, 0.01, dtype=float)
    [theCurve, x0] = CalCurve_dB(theSnr_dB, B, C)
    plt.plot(theSnr_dB, np.log10(theCurve))
    [theCurve, x0] = CalCurve_dB(theSnr_dB, B, 8*C)
    plt.plot(theSnr_dB, np.log10(theCurve))
    [theCurve, x0] = CalCurve_dB(theSnr_dB, B, 64*C)
    plt.plot(theSnr_dB, np.log10(theCurve))
    plt.grid()
    plt.show()


    # N = 64

    # theSnr_dB = np.arange(-10.0, 10.0, 0.1, dtype=float)
    # theRho_dB = np.arange(-6.0, 6.0, 0.1, dtype=float)
    # theNoiseMag_lin = np.power(10.0, -theSnr_dB/20)
    # theRho_lin = np.power(10.0, theRho_dB/20)
    # theResult = np.zeros((len(theNoiseMag_lin), len(theRho_lin)), dtype=float)
    # for idx in range(len(theResult)):
    #     theResult[idx] = 20 * np.log10(CalNonameCurve(theRho_lin, theNoiseMag_lin[idx], N))
    # fig = plt.figure()
    # ax = fig.gca(projection='3d')
    # X, Y = np.meshgrid(theRho_dB, theSnr_dB)
    # ax.plot_surface(X, Y, theResult, rstride=1, cstride=1, cmap='rainbow')
    # plt.show()

    # theRho_lin = np.arange(0.0, 4.0, 0.001, dtype=float)
    # theCurve = CalNonameCurve(theRho_lin, N)
    # plt.plot(theRho_lin, theCurve)
    # plt.grid()
    # plt.show()
    
    # theP_dB = np.arange(-5.0, 20.0, 0.2, dtype=float)
    # theRho_dB = np.arange(-5.0, 20.0, 0.2, dtype=float)
    # theP_lin = np.power(10.0, theP_dB/10)
    # theRho_lin = np.power(10.0, theRho_dB/20)
    # #theP_lin = np.arange(0.01, 20.0, 0.1, dtype=float)
    # #theRho_lin = np.arange(0.01, 6.0, 0.1, dtype=float)
    
    # theResult = np.zeros((len(theP_lin), len(theRho_lin)), dtype=float)

    # for idx in range(len(theResult)):
    #     theCurve, theCumulateCurve = CalTheCurve(theRho_lin, theP_lin[idx], N)
    #     theResult[idx] = theCurve
    
    # fig = plt.figure()
    # ax = fig.gca(projection='3d')
    # X, Y = np.meshgrid(theRho_dB, theP_dB)
    # ax.plot_surface(X, Y, theResult, rstride=1, cstride=1, cmap='rainbow')
    # plt.show()

    #plt.plot(val_lin, theCurve)
    #plt.plot(val_lin, theCumulateCurve)
    #plt.grid()
    #plt.show()


