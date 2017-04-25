From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] tpmdd fixes for 4.12
Date: Tue, 25 Apr 2017 10:04:20 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1704251004100.8213@namei.org>
References: <20170424213710.qrc5za4tigjdqspi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170424213710.qrc5za4tigjdqspi@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 25 Apr 2017, Jarkko Sakkinen wrote:

> Hi
> 
> Here are fixes for the 4.12 release. In addition there is an update to
> the tpm_tis driver to use common callbacks for requesting and
> relinquishing locality as they were with locality support for tpm_crb.
> Now the logic flow for both driver is driven in tpm_transmit().
> 

pulled, thanks!

-- 
James Morris
<jmorris@namei.org>

