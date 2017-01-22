From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via    a device link /dev/tpms<n>
Date: Sun, 22 Jan 2017 09:49:02 -0800
Message-ID: <1485107342.2504.7.camel@HansenPartnership.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
         <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
         <1484751663.2717.10.camel@HansenPartnership.com>
         <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
         <1484828380.3140.11.camel@HansenPartnership.com>
         <20170120133914.2wk43nteh2hh7n3c@intel.com>
         <20170120210522.glx4y4oui36oimld@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170120210522.glx4y4oui36oimld@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-01-20 at 23:05 +0200, Jarkko Sakkinen wrote:
> 'tabrm4' branch has been now rebased. It's now on top of master
> branch
> that contains Stefan's latest patch (min body length check) that I've
> reviewed and tested. It also contains your updated /dev/tpms patch.
> 
> I guess the 5 commits that are there now are such that we have fairly
> good consensus, don't we? If so, can I add your reviewed-by and
> tested-by to my commits and vice versa?

We're still failing my test_transients.  This is the full python of the
test case:


    def test_transients(self):
        k = self.open_transients()
        self.c.flush_context(k[0])
        self.c.change_auth(self.c.SRK, k[1], None, pwd1)
        ...

It's failing at self.c.flush_context(k[0]) with TPM_RC_VALUE.  It's the
same problem Ken complained about: TPM2_FlushContext doesn't have a
declared handle area so we don't translate the handle being sent down. 
 We have to fix this either by intercepting the flush and manually
translating the context, or by being dangerously clever and marking
flush as a command which takes one handle.

James

